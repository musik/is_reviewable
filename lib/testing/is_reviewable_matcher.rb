# RSpec matcher to spec reviewable settings
# usage:
#
# it { should be_reviewable.by(:users, :profiles) }
# it { should be_reviewable.with_scale_of(1..5) }
# it { should be_reviewable.accepting_ips(['192.168.1.20']) }
# it { should be_reviewable.with_precision_of(2) }

RSpec::Matchers.define :be_reviewable do
  match do |model|
    @klass = model.class

    @valid = true
    @valid&= klass_reviewable?
    @valid&= by_matches? if @by
    @valid&= scale_matches? if @scale
    @valid&= accept_ip_matches? if @accept_ip
    @valid&= total_precision_matches? if @total_precision
    @valid
  end

  chain(:by)                { |*values|   @by = values }
  chain(:with_scale_of)     { |scale|     @scale = convert_scale(scale) }
  chain(:accepting_ips)     { |ips|       @accept_ip = ips }
  chain(:with_precision_of) { |precision| @total_precision = precision }

  description do
    desc = 'reviewable'
    desc+= " by #{@by.map(&:to_s).join(', ')}" if @by
    desc+= " with scale of #{@scale}" if @scale
    desc+= " accepting #{@accept_ip} as ips" if @accept_ip
    desc+= " with precision of #{@total_precision}" if @total_precision
    desc
  end

  failure_message_for_should do
    if klass_reviewable?
      if @total_precision && !total_precision_matches?
        msg = "expected to be reviewable with precision of: #{@total_precision},"
        msg += " but it's precision is #{@klass.is_reviewable_options[:total_precision]}"
      end

      if @accept_ip && !accept_ip_matches?
        msg = "expected to be reviewable accepting the following ips: #{@accept_ip.join(', ')},"
        msg += " but accepts #{@klass.is_reviewable_options[:accept_ip].join(', ')}"
      end

      if @scale && !scale_matches?
        msg = "expected to be reviewable with scale of #{@scale},"
        msg += " but is the scale is #{@klass.is_reviewable_options[:scale]}"
      end

      if @by && !by_matches?
        msg = "expected to be reviewable by #{@by.map(&:to_s).join(', ')},"
        msg += " but is reviewable by #{@klass.is_reviewable_options[:by].map(&:to_s).join(', ')}"
      end
    else
      msg = 'is not reviewable'
    end

    msg
  end

  def convert_scale(scale)
    if scale.is_a?(::Range) && scale.first.is_a?(::Float)
      steps = scale.last - scale.first + 1
      step = (scale.last - scale.first) / (steps - 1)

      scale.first.step(scale.last, step).collect { |value| value }
    else
      scale.to_a.collect { |v| v.to_f }
    end
  end

  def klass_reviewable?
    @klass.respond_to?(:is_reviewable_options)
  end

  def by_matches?
    @klass.is_reviewable_options[:by] == @by &&
      @klass.is_reviewable_options[:reviewer_classes] == @by.map {|by| by.to_s.singularize.classify.constantize }
  rescue
    false
  end

  def scale_matches?
    @klass.is_reviewable_options[:scale] == @scale
  end

  def accept_ip_matches?
    @klass.is_reviewable_options[:accept_ip] == @accept_ip
  end

  def total_precision_matches?
    @klass.is_reviewable_options[:total_precision] == @total_precision
  end

end