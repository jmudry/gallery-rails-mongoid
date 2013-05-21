class HomeController < ApplicationController

  def root_page
    @formats = Album.collection.aggregate(
      { "$unwind" => "$photos"},
      { "$group" =>
          { _id: "$photos.image_content_type",
            count: {"$sum" =>  1}}
      },
      {"$project" => {_id: 0, label: "$_id", value: "$count"}} )

    @dates = Album.collection.aggregate(
      { "$unwind" => "$photos"},
      { "$group" => { _id: {
                          year: { "$year" => "$photos.image_updated_at" },
                          month: { "$month" =>  "$photos.image_updated_at" },
                          day: { "$dayOfMonth" => "$photos.image_updated_at" }},
                      count: {"$sum" =>  1}}},
      {"$project" => {
        _id: 0,
        label: "$_id",
        value: "$count"}
      }).collect.map{|x,y| {y: x["label"].map{|x,y| y}.join("-"), x: x["value"]}}

  end
end
