project = Project.find_by_full_path('ops/java-base')
builds_with_artifacts =  project.builds.with_existing_job_artifacts(Ci::JobArtifact.trace)
admin_user = User.find_by(username: 'ataburkin')
builds_to_clear = builds_with_artifacts.where("finished_at < ?", 3.months.ago)
builds_to_clear.find_each do |build|
  print "Ci::Build ID #{build.id}... "

  if build.erasable?
    Ci::BuildEraseService.new(build, admin_user).execute
    puts "Erased"
  else
    puts "Skipped (Nothing to erase or not erasable)"
  end
end