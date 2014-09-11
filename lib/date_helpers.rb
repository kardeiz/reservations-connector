module DateHelpers

  def short_date_today(tz = nil)
    short_date(Time.now.in_time_zone(tz))
  end

  def short_time_now(tz = nil)
    short_time(Time.now.in_time_zone(tz))
  end

  def short_date(_date)
    _date.strftime('%Y%m%d')
  end

  def short_time(_time)
    _time.strftime('%H%M%S')
  end

  def read_short_datetime(_dt, tz = nil)
    Time.parse(_dt).in_time_zone(tz)
  end

  def parse_short_date(_date, tz = nil)
    _date == 'today' ? short_date_today(tz) : _date
  end

  def parse_short_time(_time, tz = nil)
    _time == 'now' ? short_time_now(tz) : _time
  end

  def parse_datetime_for_short_date(_dt, tz = nil)
    short_date Time.parse(_dt).in_time_zone(tz)
  end

  def parse_datetime_for_short_time(_dt, tz = nil)
    short_time Time.parse(_dt).in_time_zone(tz)
  end

end
