require 'rails_generator/generators/components/scaffold/scaffold_generator'

class CustomScaffoldGenerator < ScaffoldGenerator
  def initialize(args1, args2)
    super(args1,args2)
  end

  def manifest
    record do |m|
      # Check for class naming collisions.
      m.class_collisions("#{controller_class_name}Controller", "#{controller_class_name}Helper")
      m.class_collisions(class_name)

      # Controller, helper, views, test and stylesheets directories.
      m.directory(File.join('app/models', class_path))
      m.directory(File.join('app/controllers', controller_class_path))
      m.directory(File.join('app/helpers', controller_class_path))
      m.directory(File.join('app/views', controller_class_path, controller_file_name))
      m.directory(File.join('app/views/layouts', controller_class_path))
      m.directory(File.join('test/functional', controller_class_path))
      m.directory(File.join('test/unit', class_path))
      m.directory(File.join('public/stylesheets', class_path))

      for action in scaffold_views
        m.template(
          real_path("view_#{action}.html.erb"),
          File.join('app/views', controller_class_path, controller_file_name, "#{action}.html.erb")
        )
      end

      # Layout and stylesheet.
      m.template(real_path('layout.html.erb'), File.join('app/views/layouts', controller_class_path, "#{controller_file_name}.html.erb"))
      m.template(real_path('style.css'), 'public/stylesheets/scaffold.css')



      m.template(
        real_path('controller.rb'), File.join('app/controllers', controller_class_path, "#{controller_file_name}_controller.rb")
      )


      m.template(
        real_path('helper.rb'),File.join('app/helpers',controller_class_path, "#{controller_file_name}_helper.rb")
      )


      m.template(
        real_path('functional_test.rb'), File.join('test/functional', controller_class_path, "#{controller_file_name}_controller_test.rb")
      )

      m.route_resources controller_file_name

      m.dependency 'model', [name] + @args, :collision => :skip
    end
  end

  private
  def real_path(template_name)
    File.exist?(source_path(template_name)) ? template_name : "scaffold:#{template_name}"
  end
end
