class Snake < Formula
  desc "snake, in C, with ncurses!"
  homepage ""
  head "https://github.com/jvns/snake.git"
  
  def install
    system "make"
    bin.install "snake"
  end

  test do
    system "true"
  end
end
