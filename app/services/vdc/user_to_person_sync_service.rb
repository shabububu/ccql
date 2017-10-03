# Service to create and update a Fedora Person object, given a user.

# TODO: Get rid of all the repetition please...

class Vdc::UserToPersonSyncService

  def initialize(params)
    @user = params[:user]
  end

  def create_person_from_user(user)
    # TODO: Understand how transactions work in Fedora and
    #       make sure it's being done properly here.
    # TODO: before saving, do some validation on the Person to make sure it's constructed properly
    p = ::Vdc::Person.new
    p.vdc_type = "Person"
    p.orcid = ::RDF::URI(user.orcid)
    p.preferred_name = user.last_name + ", " + user.first_name

    # TODO: How do I auto-populate p.authoritative_name and p.authoritative_name_uri?
    #       Currently, left blank.
    # p.authoritative_name = ?
    # p.authoritative_name_uri = ?

    p.edu_person_principal_name = user.edu_person_principal_name if user.edu_person_principal_name != nil

    p.email = user.email
    # TODO: This "other" should probably be a constant somewhere...
    if user.organization.downcase == "other" then
      p.organization = user.organization_other
    else
      p.organization = user.organization
    end

    p.department = user.department
    p.position = user.position
    p.discipline = user.discipline
    p.website = user.website
    p.save

    # https://github.com/samvera/hydra/wiki/Lesson---Adding-attached-files
    # TODO: Find out what to add to make this adhere to PCDM standards
    # TODO: some validation here
    if !user.cv_file.file.nil?
      file_path = user.cv_file.current_path
      p.cv_upload.content = File.open(file_path)
      p.cv_upload.mime_type = user.cv_file.content_type
      p.cv_upload.original_name = user.cv_file_identifier
      p.save
      p.cv = p.cv_upload.uri
      p.save
    elsif user.cv_link.gsub(/\s+/, '') != ''
      p.cv = RDF::URI(user.cv_link)
      p.save
    end
      
    # Additional post-proessing
    # TODO: Is there a better way to do this?
    p.identifier_system = p.id
    p.save

    # Now that we have the person id in Fedora, we can save it to user
    user.identifier_system = p.id
    user.save

    p
  end

  def update_person_from_user(user)
    # TODO: before saving, do some validation on the Person to make sure it's constructed properly
    p = ::Vdc::Person.find(user.identifier_system)
    if p.nil?
      flash[:error] = "This person (#{user.identifier_system}) does not exist."
      return
    end

    p.orcid = ::RDF::URI(user.orcid)
    p.preferred_name = user.last_name + ", " + user.first_name

    # TODO: How do I auto-populate p.authoritative_name and p.authoritative_name_uri?
    #       Currently, left blank.
    # p.authoritative_name = ?
    # p.authoritative_name_uri = ?

    p.edu_person_principal_name = user.edu_person_principal_name if user.edu_person_principal_name != nil

    p.email = user.email
    # TODO: This "other" should probably be a constant somewhere...
    if user.organization.downcase == "other" then
      p.organization = user.organization_other
    else
      p.organization = user.organization
    end

    p.department = user.department
    p.position = user.position
    p.discipline = user.discipline
    p.website = user.website

    # https://github.com/samvera/hydra/wiki/Lesson---Adding-attached-files
    # TODO: I have no idea if this adheres to pcdm standards. Find out.
    # TODO: some validation here
    if !user.cv_file.file.nil?
      file_path = user.cv_file.current_path
      p.cv_upload.content = File.open(file_path)
      p.cv_upload.mime_type = user.cv_file.content_type
      p.cv_upload.original_name = user.cv_file_identifier
      p.save
      p.cv = p.cv_upload.uri
    elsif user.cv_link.gsub(/\s+/, '') != ''
      p.cv = RDF::URI(user.cv_link)
    end
      
    p.save
    p
  end
end
