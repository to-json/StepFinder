class StepFinder

  def initialize(directory)
    Dir.chdir(directory) do
      conf = Cucumber::Configuration.default
      @support = Cucumber::Runtime::SupportCode.new(nil, conf)
      @support.load_files_from_paths(conf.autoload_code_paths)
      @transforms = @support.load_programming_language('rb').send(:transforms)
    end
  end

  def match_steps(query)
    match = @support.step_match(query)
    transforms = match.args.map do |arg|
      @transforms.detect { |transform| transform.match(arg) }
    end.compact.map { |transform| format_transform(transform) }
    format_step(match.step_definition, transforms: transforms, args: match.args)
  rescue Cucumber::Undefined
    return nil
  end

  def search_steps(query)
    steps = @support.step_definitions.select do |step_definition|
      step_definition.regexp_source.include? query
    end
    steps.map { |step_definition| format_step(step_definition) }
  end
  
  private

  def format_step(step, transforms: [], args: nil)
    { regex: step.regexp_source,
      code: get_proc_source(step),
      args: args,
      transforms: transforms,
      file_source: step.file_colon_line }
  end

  def format_transform(transform)
    transform_proc = transform.instance_variable_get(:@proc)
    { regex: transform.to_s,
      code: get_proc_source(transform),
      file_source: format_transform_file(transform_proc.source_location) }
  end

  def format_transform_file(file)
    "#{file.first.sub(Dir.pwd + '/', '')}:#{file.last.to_s}"
  end

  def get_proc_source(step)
    step.instance_variable_get(:@proc).source
  rescue MethodSource::SourceNotFoundError
    "Unable to parse source (This may indicate that it needs a refactor)"
  end
end
