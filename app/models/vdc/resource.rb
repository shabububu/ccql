# Generated via
#  `rails generate hyrax:work Vdc::Resource`
class Vdc::Resource < ActiveFedora::Base
  include ::Hyrax::WorkBehavior
  include ::Hyrax::BasicMetadata
  # Change this to restrict which works can be added as a child.
  # self.valid_child_concerns = []

  # The following are validations for the resource work, regardless of what 
  # visibility is selected. Form-level validations will also exist for those
  # that do change based on visibility.
  validates :title, presence: { message: 'Your resource must have a title.' }
  #validates :vdc_creator, presence: { message: 'Your resouce must have a creator.' }
  #validates :genre, presence: { message: 'Your resource must have a genre.' }
  
  #self.human_readable_type = 'Vdc/Resource'
  self.human_readable_type = 'Resource'

  property :vdc_type, predicate: ::RDF::URI("https://datacollaboratory.org/resource#vdcType"), multiple: false do |index|
    index.as :stored_searchable, :facetable # TODO: Should this be searchable?
  end

  property :identifier_system, predicate: ::RDF::URI("https://datacollaboratory.org/resource#identifierSystem"), multiple: false

  property :identifier_doi, predicate: ::RDF::URI("https://datacollaboratory.org/resource#identifierDoi"), multiple: false do |index|
    index.as :stored_searchable, :facetable # TODO: Should this be searchable?
  end  

  property :vdc_creator, predicate: ::RDF::URI("https://datacollaboratory.org/resource#creator"), multiple: false do |index|
    index.as :stored_searchable # TODO: Should this be searchable?
  end

  property :authoritative_name, predicate: ::RDF::URI("https://datacollaboratory.org/person#authoritativeName"), multiple: false do |index|
    index.as :stored_searchable, :facetable
  end

  property :authoritative_name_uri, predicate: ::RDF::URI("https://datacollaboratory.org/person#authoritativeNameUri"), multiple: false do |index|
    index.as :stored_searchable, :facetable
  end

  # NOTE: :title already exists as core metadata (default is multiple, which needs to be turned off in the form)
  #       http://samvera.github.io/customize-metadata-model.html#core-metadata
  #       The pre-existing title must exist, but we'll create an additional
  #       :vdc_title mapped to a different predicate in post-processing.

  # To be set from :title in post processing
  property :vdc_title, predicate: ::RDF::URI("https://datacollaboratory.org/resource#title"), multiple: false do |index|
    index.as :stored_searchable, :facetable
  end

  property :genre, predicate: ::RDF::URI("https://datacollaboratory.org/resource#genre"), multiple: false do |index|
    index.as :stored_searchable, :facetable
  end

  # NOTE: :description (for abstract) already exists as basic metadata (default is multiple)
  #       However, I'm deleting it in favor of :abstract with our own predicate
  #       http://samvera.github.io/customize-metadata-model.html#basic-metadata
  
  property :abstract, predicate: ::RDF::URI("https://datacollaboratory.org/resource#abstract"), multiple: false do |index|
    index.as :stored_searchable, :facetable
  end

  property :funder, predicate: ::RDF::URI("https://datacollaboratory.org/resource#funder"), multiple: true do |index|
    index.as :stored_searchable, :facetable
  end

  property :research_problem, predicate: ::RDF::URI("https://datacollaboratory.org/resource#researchProblem"), multiple: false do |index|
    index.as :stored_searchable, :facetable
  end

  property :note, predicate: ::RDF::URI("https://datacollaboratory.org/resource#note"), multiple: true do |index|
    index.as :stored_searchable, :facetable
  end

  property :readme, predicate: ::RDF::URI("https://datacollaboratory.org/resource#readme"), multiple: true do |index|
    index.as :stored_searchable, :facetable
  end

  # NOTE: :date_created (for creationDate) already exists as basic metadata (default is multiple, 
  #       which needs to be turned off in the form)
  #       http://samvera.github.io/customize-metadata-model.html#basic-metadata

  # TODO: Is this searchable?
  property :extent, predicate: ::RDF::URI("https://datacollaboratory.org/resource#extent"), multiple: false

  # TODO: Is this searchable?
  property :format, predicate: ::RDF::URI("https://datacollaboratory.org/resource#format"), multiple: true

  property :coverage_spatial, predicate: ::RDF::URI("https://datacollaboratory.org/resource#coverageSpatial"), multiple: true do |index|
    index.as :stored_searchable, :facetable
  end

  property :coverage_temporal, predicate: ::RDF::URI("https://datacollaboratory.org/resource#coverageTemporal"), multiple: true do |index|
    index.as :stored_searchable, :facetable
  end

  # NOTE: :license already exists as basic metadata (default is multiple, which needs to be turned off in the form)
  #       http://samvera.github.io/customize-metadata-model.html#basic-metadata

end
