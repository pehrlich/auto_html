module AutoHtmlFor

  # default options that can be overridden on the global level
  @@auto_html_for_options = {
    :htmlized_attribute_suffix => '_html'
  }
  mattr_reader :auto_html_for_options

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def auto_html_for(raw_attrs, &proc)
      include AutoHtmlFor::InstanceMethods
      before_save :auto_html_prepare


      define_method("auto_html_prepare") do
        auto_html_methods = self.methods.select { |m| m=~/^auto_html_prepare_/ }
        auto_html_methods.each do |method|
          self.send(method)
        end
      end

      suffix =  AutoHtmlFor.auto_html_for_options[:htmlized_attribute_suffix]

      [raw_attrs].flatten.each do |raw_attr|
        define_method("#{raw_attr}#{suffix}=") do |val|
          # this would work except write_attribute persists, unlike in rails
          #write_attribute("#{raw_attr}#{suffix}", val)
          # note that when description_html is read, it is also written
          # this happens when first being created, so we skip it there
          if @properties_before_type_cast
            write_local_property("#{raw_attr}#{suffix}", val)
          else
          end
        end
        define_method("#{raw_attr}#{suffix}") do
          # don't write on read because it breaks dirty attribute tracking and is generally a clusterfuck.
          #result = read_attribute("#{raw_attr}#{suffix}") || send("auto_html_prepare_#{raw_attr}")
          result = read_local_property("#{raw_attr}#{suffix}")
          result.respond_to?(:html_safe) ?
            result.html_safe :
              result
        end
        define_method("auto_html_prepare_#{raw_attr}") do
          self.send(raw_attr.to_s + suffix + "=", 
            auto_html(self.send(raw_attr), &proc))
        end
      end
    end
  end

  module InstanceMethods
    include AutoHtml
  end
end