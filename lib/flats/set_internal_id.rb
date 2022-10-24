# frozen_string_literal: true

module Flats
  class SetInternalId
    def call
      count = FlatsHist.count
      i = 0
      FlatsHist.find_each do |flat|
        flat.internal_id = flat.hash_internal_key
        flat.save!
        i += 1

        print "#{i} / #{count}"
      end
    end

    def img_id
      count = FlatsHist.count
      i = 0
      FlatsHist.find_each do |flat|
        flat.img_id = flat.img_key
        flat.save!
        i += 1

        print "#{i} / #{count} (#{(i.to_f / count * 100).round} %)".ljust(30) + "\r"
      end
    end
  end
end
