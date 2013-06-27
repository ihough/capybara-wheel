

# class SubElement < Element

#   def initialize(container)
#     @container = container
#   end

#   attr_reader :container

#   protected

#   def containing_capybara_element
#     container.send(:capybara_element)
#   end

#   def capybara_element
#     raise NotImplementedError, "implement me, e.g. using containing_capybara_element.find" unless @selector
#     containing_capybara_element.find(@selector)
#   end

# end