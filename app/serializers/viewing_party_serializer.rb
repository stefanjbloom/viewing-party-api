class ViewingPartySerializer
  include JSONAPI::Serializer

  attributes :name, :start_time, :end_time, :movie_id, movie_title

  attribute :invitees do |viewing_party|
    viewing_party.invitees.map do |invitee|
      {
        id: invitee.id,
        name: invitee.name,
        username: invitee.username
      }
    end
  end
end
