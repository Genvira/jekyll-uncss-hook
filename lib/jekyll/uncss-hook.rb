# frozen_string_literal: true

require "tempfile"

Jekyll::Hooks.register(:site, :post_write) do |site|
  # next if ENV["JEKYLL_ENV"] != "production"

  Jekyll.logger.info "UNCSS:"

  config = site.config["uncss"] || {}

  # Ensure the stylesheets option is set
  unless config.key?("stylesheets")
    Jekyll.logger.info "Uncss config: #{config}"
    raise "Missing option 'uncss.stylesheets'!"
  end

  # Get a list of all files matching the glob
  files = config.fetch("files", ["**/*.html"]).collect do |glob|
    glob = File.join(site.dest, glob)
    files = Dir[glob]
    files
  end.flatten.uniq

  Jekyll.logger.info "Files matching uncss-hook files config"
  files.each do |filepath|
    Jekyll.logger.info "- #{filepath}"
  end

  # Produce Uncss instance
  uncss = Jekyll::UncssHook::UnCSS.new(files,
    htmlroot: site.dest,
    ignore: config["ignore"],
    media: config["media"],
    ignore_sheets: config["ignoreSheets"],
    raw: config["raw"],
    timeout: config["timeout"],
    banner: config["banner"],
    inject: config["inject"])

  # Process each given stylesheet
  config["stylesheets"].each do |stylesheet|
    Jekyll.logger.info "- Processing #{stylesheet}"

    # Run through uncss
    result = uncss.process(stylesheet)

    # Write the processed CSS file to disk
    output_file_path = File.join(site.dest, stylesheet)
    Jekyll.logger.info "  Writing to #{output_file_path}"
    File.write(output_file_path, result)
    Jekyll.logger.info "  Done writing to #{output_file_path}"
  rescue Error => e
    raise error, "Something failed: #{e} :: #{result}"
  end

  Jekyll.logger.info "UnCSS hook complete. Processed #{config["stylesheets"].length} css files"
  Jekyll.logger.info "UnCSS hook complete. Processed #{config["stylesheets"].length} css files Test stuff"
end

module Jekyll
  module UncssHook
    class UnCSS
      # Constructor for UnCSS class
      # @param files [Array<String>] An array >>>of the paths to the HTML files
      # @options [Map] The other options
      def initialize(files, **options)
        @files = [files].flatten.uniq
        @options = options.compact
      end

      # Process a CSS file
      # @param css_file [String] The path to the CSS file to process
      def process(css_file)
        # Create config
        make_config(css_file)

        result = run_uncss

        yield(result) if block_given?

        result
      end

      # Create a config file for the css file
      # @param css_file [String] the path to the CSS file
      def make_config(css_file)
        options = @options.clone

        # Path is relative to htmlroot, so should start with "/"
        options[:stylesheets] = [(css_file.start_with?("/") ? css_file : ("/" + css_file))]

        Jekyll.logger.info "  - Config used: #{options.to_json}"

        cleanup_config
        @temp_file = Tempfile.new("uncssrc")
        @temp_file.write(options.to_json)
        @temp_file.flush
      end

      # Ensure there aren't any previous config files open
      def cleanup_config
        return if @temp_file.nil?

        @temp_file.close
        @temp_file.unlink
      end

      # Run UnCSS
      def run_uncss
        config_path = @temp_file.path
        files = "'#{@files.join("' '")}'"

        # Banner option in uncssrc doesn't seem to work
        banner_option = @options[:banner] ? "" : "--noBanner"

        # Run UnCSS command
        Jekyll.logger.info "  - UnCSS command: uncss --uncssrc '#{config_path}' #{banner_option} #{files}"
        result = `uncss --uncssrc '#{config_path}' #{banner_option} #{files}`

        result.strip!

        result
      rescue Error => e
        raise error, "UnCSS failed: #{e} :: #{result}"
      end
    end
  end
end
