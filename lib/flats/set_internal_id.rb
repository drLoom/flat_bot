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
      hists = FlatsHist.select('DISTINCT ON (object_id) flats_hist.*')
      count = hists.size

      i = 0
      hists.each_slice(1000) do |batch|
        object_id_img_key = batch.map { |fh| "(#{fh.object_id}, #{fh.img_key})" }

        query = <<~SQL
          UPDATE flats_hist
          SET img_id=incoming.img_key
          FROM (
            values #{object_id_img_key.join(', ')}
          ) incoming(object_id, img_key)
          WHERE flats_hist.object_id=incoming.object_id;
        SQL

        ApplicationRecord.connection.execute(query)

        i += batch.size

        print "#{i} / #{count} (#{(i.to_f / count * 100).round} %)".ljust(30) + "\r"
      end
    end
  end
end
