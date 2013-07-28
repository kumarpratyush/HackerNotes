$RESOURCE_TYPES = [:blogs, :subscription_services, :tips, :slides, :tutorials, :examples, :qnas, :screencasts, :talks, :noteworthies]

[Repository.where(name: 'bootstrap').first].each do |repository|
  Rails.logger.info "Updating repository: #{repository.name}"

  $RESOURCE_TYPES.each do |resource_type|
    next if repository.send(resource_type).empty?
    Rails.logger.info "Updating resource type: #{resource_type}"

    repository.send(resource_type).each do |resource|
      next if resource.votes.empty?
      Rails.logger.info "Updating resource: #{resource.title} - #{resource.url}"

      resource.votes.keys.each do |username|
        points = resource.votes[username]
        resource.votes[username] = { points: points, time: Time.zone.now }
      end

      Rails.logger.info "Updated resource: #{resource.votes}"
    end

    repository.save
  end

end
