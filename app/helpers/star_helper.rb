# frozen_string_literal: true

module StarHelper
  def gone?(star)
    star.latest_hist.date != FlatsHist.last_date
  end
end
