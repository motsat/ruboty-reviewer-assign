# TODO 消す
Dotenv.load

module Ruboty
	module Handlers
		class Review < Base
      require 'octokit'
      require 'active_support/core_ext/string/filters'
      require 'redis-objects'

      on(/review/i, name: "review", description: "assign review")

			def review(message)
        team, pull_request_url = parse_message(message.body)
        team_members_of(team: team)
        request_pull_request_review(pull_request_id_by(url: pull_request_url))
				message.reply("Hello!!")
			end

      private
      def team_members_of(team: )
        team_github_acounts = Redis::List.new('team_github_acounts')
      end

      def parse_message(message_body)
        vars = message_body.squish.split " "
        group, pull_request_url = 
          case vars.size
          when 3
            return [nil, vars[2]]
          when 4
            return [vars[2], vars[3]]
          else
            raise
          end
      end

      def pull_request_id_by(url:)
        url.split("/").last
      end

      def request_pull_request_review(pull_request_id)
        octokit = Octokit::Client.new(access_token: ENV["OCTOKIT_ACCESS_TOKEN"])
        octokit.request_pull_request_review(ENV["GITHUB_REPOSITORY"], pull_request_id, reviewers: ["mo10sa10"])
      end
		end
	end
end
