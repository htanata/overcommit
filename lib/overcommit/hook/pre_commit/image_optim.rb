module Overcommit::Hook::PreCommit
  # Checks for images that can be optimized with `image_optim`.
  class ImageOptim < Base
    def run
      begin
        require 'image_optim'
      rescue LoadError
        return :warn, 'image_optim not installed -- run `gem install image_optim`'
      end

      optimized_images =
        begin
          optimize_images(applicable_files)
        rescue ::ImageOptim::BinNotFoundError => e
          return :bad, "#{e.message}. The image_optim gem is dependendent on this binary."
        end

      if optimized_images.any?
        return :bad,
          "The following images were optimized:\n" <<
          optimized_images.join("\n") <<
          "\nPlease add them to your commit."
      end

      :good
    end

  private

    def optimize_images(image_paths)
      image_optim = ::ImageOptim.new(:pngout => false)

      optimized_images =
        image_optim.optimize_images!(image_paths) do |path, optimized|
          path if optimized
        end

      optimized_images.compact
    end
  end
end
