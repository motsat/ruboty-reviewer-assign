require 'ruboty/reviewer_assign/parsers/assign'

module Ruboty
  module ReviewerAssign
    module Actions
      class Assign < Ruboty::Actions::Base
        def call
          message.reply(assign)
        rescue Ruboty::ReviewerAssign::Parsers::Base::ParseError => e
          message.reply(e.message)
        end

        private
        def assign
          tag, pull_request_url = Ruboty::ReviewerAssign::Parsers::Assign.new(message).parse

          reviewers = tag ?  Reviewer.by_tag(tag) : Reviewer.all

          # reject self
          reviewers.reject! {|r| r.slack_member_id == message.original[:user]["id"] }

          return "<@#{message.original[:user]["id"]}> レビュアーが見つかりません:tired_face:" if reviewers.size == 0
          reviewer = reviewers.sort(&:last_reviewed_at).first
          github_api.assign_reviewer(pull_request_url, [reviewer.github_account])
          to = reviewers.map { |l| "<@#{l.slack_member_id}>" }.join " "
          reviewers.each do |l| 
            l.last_reviewed_at = Time.now
            l.save!
          end
          "レビューお願いします:pray: #{pull_request_url}\n#{to}"
        end

        def github_api
          GithubAPI.new
        end
      end
    end
  end
end
