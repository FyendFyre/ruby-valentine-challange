class WireworldValentine
  EMPTY         = "🟪" # State 0
  ELECTRON_HEAD = "🟥" # State 1
  ELECTRON_TAIL = "⬜" # State 2
  CONDUCTOR     = "🟨" # State 3

  def initialize(rows:, cols:)
    @rows = rows
    @cols = cols
    @grid = Array.new(rows) { Array.new(cols, EMPTY) }
  end

  def self.load(filename)
    # parse the file data
    file = File.open(filename)
    data =
      file
        .readlines(chomp: true)
        .map(&:chars)

    # create the game
    self
      .new(rows: data.length, cols: data[0].length)
      .tap { |game| game.instance_variable_set(:@grid, data) }
  end

  def display
    system("clear") || system("cls")

    puts @grid.collect(&:join)
  end

  ######################################################################
  # Implement the below method. Rules for Wireworld may be found on wiki
  # https://en.wikipedia.org/wiki/Wireworld
  ######################################################################
  def tick
    # Hint: mutate @grid
    grid_copy = @grid.map(&:clone)
    @grid.each_index do |row_index|
      @grid[row_index].each_index do |column_index|
        count = 0
        if @grid[row_index][column_index] == "🟥"
          grid_copy[row_index][column_index] = "⬜"
        elsif @grid[row_index][column_index] == "⬜"
          grid_copy[row_index][column_index] = "🟨"
        elsif @grid[row_index][column_index] == "🟨"
          neigh = neighbours(@grid,[row_index,column_index])
          neigh.each do |ele|
            if ele == "🟥"
              count += 1
            end
          end
          if count == 2 or count == 1
            grid_copy[row_index][column_index] = "🟥"
          end
        end
      end
    end
    @grid = grid_copy.map(&:clone)
  end

  def neighbours(array, (i , j))
    [
      [i, j - 1],
      [i, j + 1],
      [i - 1, j - 1],
      [i - 1, j],
      [i - 1, j + 1],
      [i + 1, j - 1],
      [i + 1, j],
      [i + 1, j + 1],
    ].select { |h, w|
        h.between?(0, array.length - 1) && w.between?(0, array.first.length - 1)
      }.map do |row, col|
          array[row][col]
      end
  end

  def run(steps=nil)
    (0..steps).each do
      display
      tick
      sleep 1
    end
  end
end

WireworldValentine.load(ARGV[0]).run
__END__
