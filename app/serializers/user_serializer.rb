class UserSerializer
  include JSONAPI::Serializer
  attributes :name, :username, :api_key

  attribute :hosted_viewing_parties do |user|
    user.hosted_viewing_parties.map do |party|
      {
        id: party.id,
        name: party.name,
        start_time: party.start_time,
        end_time: party.end_time,
        movie_id: party.movie_id,
        movie_title: party.movie_title,
        host: user.id
      }
    end
  end

  attribute :invited_viewing_parties do |user|
    user.invited_viewing_parties.map do |party|
      {
        name: party.name,
        start_time: party.start_time,
        end_time: party.end_time,
        movie_id: party.movie_id,
        movie_title: party.movie_title,
        host_id: party.host_id
      }
    end
  end

  def self.format_user_profile(user)
    {
      data: {
        id: user.id.to_s,
        type: "user",
        attributes: {
          name: user.name,
          username: user.username,
          hosted_viewing_parties: user.hosted_viewing_parties.map do |party|
            {
              id: party.id,
              name: party.name,
              start_time: party.start_time,
              end_time: party.end_time,
              movie_id: party.movie_id,
              movie_title: party.movie_title,
              host: user.id
            }
          end,
          invited_viewing_parties: user.invited_viewing_parties.map do |party|
            {
              name: party.name,
              start_time: party.start_time,
              end_time: party.end_time,
              movie_id: party.movie_id,
              movie_title: party.movie_title,
              host_id: party.host_id
            }
          end
        }
      }
    }
  end

  def self.format_user_list(users)
    { data:
        users.map do |user|
          {
            id: user.id.to_s,
            type: "user",
            attributes: {
              name: user.name,
              username: user.username
            }
          }
        end
    }
  end
end