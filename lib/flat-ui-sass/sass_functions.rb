# Based on bootstrap-sass
# https://github.com/twbs/bootstrap-sass/blob/master/lib/bootstrap-sass/sass_functions.rb

require 'sass'

module Sass::Script::Functions
  def flat_ui_font_path(source)
    flat_ui_asset_path source, :font
  end
  declare :flat_ui_font_path, [:source]

  def flat_ui_image_path(source)
    flat_ui_asset_path source, :image
  end
  declare :flat_ui_image_path, [:source]

  def flat_ui_asset_path(source, type)
    return Sass::Script::String.new('', :string) if source.to_s.empty?
    url = if FlatUI.asset_pipeline? && (context = sprockets_context)
            context.send(:"#{type}_path", source.value)
          elsif FlatUI.compass?
            send(:"#{type}_url", source, Sass::Script::Bool.new(true)).value.sub /url\((.*)\)$/, '\1'
          end

    # sass-only
    url ||= source.value.gsub('"', '')
    Sass::Script::String.new(url, :string)
  end
  declare :flat_ui_asset_path, [:source, :type]

  unless Sass::Script::Functions.instance_methods.include?(:tint)
    def tint(color, percentage)
      assert_type color, :Color
      assert_type percentage, :Number
      white = Sass::Script::Color.new([255, 255, 255])
      mix(white, color, percentage)
    end
  end

  # Based on https://github.com/edwardoriordan/sass-utilities/blob/master/lib/sass-utilities.rb
  def interpolate_variable(name)
    assert_type name, :String
    environment.var(name.value)
  end
end
