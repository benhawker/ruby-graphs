require 'gruff'
require 'csv'

class StockGraphBuilder

  attr_reader :path_to_csv, :title, :graph, :currency_code

  def initialize(path_to_csv, title, pixel_width=500, currency_code="USD")
    @path_to_csv = path_to_csv
    @title = title
    @graph = Gruff::Line.new(pixel_width)
    @currency_code = currency_code
  end

  def build
    build_x_axis
    build_y_axis
    build_labels
    build_title
    graph.write(File.join(filename_builder))
  end

  private

  def csv
    CSV.read(path_to_csv, headers: true)
  end

  def build_x_axis
    x_axis = []

    csv.each { |row|  x_axis << row['Date'] }

    start_date = x_axis.min
    middle_date = x_axis[(x_axis.length ) / 2]
    end_date = x_axis.max

    graph.labels = { 0 => start_date, 50 => middle_date, 100 => end_date }
  end

  def build_y_axis
    graph.data('Opening Price', csv.collect { |x| x['Open'].to_i }, '#B75582')
    graph.data('High Price', csv.collect{ |x| x['High'].to_i }, '#79C65B' )
    graph.data('Low Price', csv.collect { |x| x['Low'].to_i })
    graph.data('Closing Price', csv.collect { |x| x['Close'].to_i })
  end

  def build_labels
    graph.x_axis_label = 'Date'
    graph.y_axis_label = currency_code
  end

  def build_title
    graph.title = title
  end

  def filename_builder
    "#{title.downcase.gsub(' ', '-')}_#{Date.today}.png"
  end
end