# -*- encoding : utf-8 -*-
# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Property::Application.initialize!
WillPaginate::ViewHelpers.pagination_options[:renderer] = 'PaginationListLinkRenderer'
