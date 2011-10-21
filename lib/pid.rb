class PID

  VERSION = '1.0'

  attr_accessor :derivative_gain

  attr_accessor :integral_gain

  attr_accessor :proportional_gain

  ##
  # The target output values

  attr_accessor :set_point

  ##
  # Creates a new PID controller

  def initialize set_point = 0, position = 0
    @set_point   = set_point.to_f
    @position    = position.to_f
    @sample_rate = 1.0 # seconds - figure this out through timing

    @integral_gain     = 0.0
    @derivative_gain   = 0.0
    @proportional_gain = 1.0

    # internal
    @derivative     = 0.0
    @integral       = 0.0
    @previous_error = @set_point - @position
  end

  ##
  # One iteration of the PID loop.  +input+ is the new measurement, returns
  # the new valve position.

  def control input
    error = @set_point - input
    @integral = @integral + error * @sample_rate
    @derivative = (error - @previous_error) / @sample_rate

    output =
      @proportional_gain * error +
      @integral_gain     * @integral +
      @derivative_gain   * @derivative

    @previous_error = error

    output
  end

  ##
  # Runs the controller loop allowing input of new measurements.
  #
  # The loop yields the current valve position and the return value of the
  # block is the new input measurement.

  def loop
    measurement = yield @position

    while true do
      position = control measurement

      measurement = yield position
    end
  end

end

