class ChaptersController < ApplicationController

private

  def chapter_params
    params.require(:chapter).permit(:content,:picture)
  end

end
