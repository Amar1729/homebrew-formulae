class Snake < Formula
  desc ", in C, with ncurses!"
  homepage "https://github.com/jvns/snake"
  head "https://github.com/jvns/snake.git"

  def install
    system "make"
    bin.install "snake"
  end

  test do
    system "true"
  end
end
