require 'minitest/autorun'
require 'pid'

class TestPID < MiniTest::Unit::TestCase

  def setup
    @pid = PID.new
  end

  def test_control_P
    @pid.set_point = 50

    output = @pid.control 0

    assert_in_delta 50.0, output
  end

  def test_control_P_2
    @pid.set_point = 50

    output = @pid.control 25

    assert_in_delta 25.0, output
  end

  def test_control_P_3
    @pid.set_point = 50

    output = @pid.control 75

    assert_in_delta(-25.0, output)
  end

  def test_control_I
    @pid.set_point = 50
    @pid.integral_gain = 0.25

    output = @pid.control 0

    assert_in_delta 62.5, output
  end

  def test_control_I_2
    @pid.set_point = 50
    @pid.integral_gain = 0.25

    output = @pid.control 25

    assert_in_delta 31.25, output
  end

  def test_control_I_3
    @pid.set_point = 50
    @pid.integral_gain = 0.25

    output = @pid.control 75

    assert_in_delta(-31.25, output)
  end

  def test_control_D
    @pid.set_point = 50
    @pid.derivative_gain = 0.25

    output = @pid.control 0

    assert_in_delta 62.5, output
  end

  def test_control_D_2
    @pid.set_point = 50
    @pid.derivative_gain = 0.25

    output = @pid.control 75

    assert_in_delta(-31.25, output)
  end

  def test_loop
    @pid.loop do |output|
      assert_equal 0, output
      break
    end
  end

end

