class Parser
  attr_reader :message
  def initialize(message)
    @message = message
  end
  def parse
    raise "abstruct method"
  end
end

class AssignParser < Parser
  def parse
    vars = message.squish.split " "
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
end

class ListsParser < Parser
  def parse
    raise NotImplementedError "No need for now"
  end
end

class UserAddParser < Parser
  def parse
    vars = message.squish.split " "
    [vars[2], vars[3]] # 1.slack_realname or email, 2.github_account
  end
end

class UserDelParser < Parser
  def parse
    vars = message.squish.split " "
    vars[2] # 1.slack_realname or email
  end
end

class ChgrpParser < Parser
  def parse
  end
end
