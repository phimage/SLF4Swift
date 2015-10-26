Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.name         = "SLF4Swift"
  s.version      = "2.0.1"
  s.summary      = "Simple Log Facade for Swift"
  s.description  = <<-DESC
                   Simple Log Facade for Swift serves as a simple facade
                   for logging frameworks allowing the end user to plug in the desired
                   logging framework at deployment time
                   DESC
  s.homepage     = "https://github.com/phimage/SLF4Swift"

  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.license      = "MIT"

  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.author             = { "phimage" => "eric.marchand.n7@gmail.com" }

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.9'
  s.watchos.deployment_target = '2.0'
  s.tvos.deployment_target = '9.0'

  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.source       = { :git => "https://github.com/phimage/SLF4Swift.git", :tag => s.version }

  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.default_subspec = 'Core'

  s.subspec "Core" do  |sp|
    sp.source_files = "SLF4Swift/*.swift"
  end

  s.subspec "Impl" do  |sp|
    sp.source_files = "SLF4Swift/Implementation/*.swift"
    sp.dependency 'SLF4Swift/Core'
  end

  ## ――― Backend ――――――――――――――――――――――――――――――――――――――――――――――――― ##
  s.subspec "CocoaLumberjack" do  |sp|
    sp.source_files = "Backend/CocoaLumberjack/*.swift"
    sp.dependency 'SLF4Swift/Core'
    sp.dependency 'CocoaLumberjack/Swift'
    sp.ios.deployment_target = '8.0'
    sp.osx.deployment_target = '10.10'
    sp.watchos.deployment_target = '2.0'
  end

  s.subspec "XCGLogger" do  |sp|
    sp.source_files = "Backend/XCGLogger/*.swift"
    sp.dependency 'SLF4Swift/Core'
    sp.dependency 'XCGLogger'
    sp.ios.deployment_target = '8.0'
    sp.osx.deployment_target = '10.9'
    sp.watchos.deployment_target = '2.0'
    sp.tvos.deployment_target = '9.0'
  end

  s.subspec "SpeedLog" do  |sp|
    sp.source_files = "Backend/SpeedLog/*.swift"
    sp.dependency 'SLF4Swift/Core'
    sp.dependency 'SpeedLog'
    sp.ios.deployment_target = '8.0'
    sp.osx.deployment_target = '10.9'
    sp.watchos.deployment_target = '2.0'
    sp.tvos.deployment_target = '9.0'
  end

  #s.subspec "QorumLogs" do  |sp|
  #  sp.source_files = "Backend/QorumLogs/*.swift"
  #  sp.dependency 'SLF4Swift/Core'
  #  sp.dependency 'SpeedLog'
  #  sp.ios.deployment_target = '8.0'
  #  sp.osx.deployment_target = '10.9'
  #end

  #s.subspec "Swell" do  |sp|
  #  sp.source_files = "Backend/Swell/*.swift"
  #  sp.dependency 'SLF4Swift/Core'
  #  sp.dependency 'Swell'
  #  sp.ios.deployment_target = '8.0'
  #  sp.osx.deployment_target = '10.9'
  #end

  # ――― Resources ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.resource  = "logo-128x128.png"

end
