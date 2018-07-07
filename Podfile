platform :ios, '11.0'

use_frameworks!

post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
        config.build_settings.delete('CODE_SIGNING_ALLOWED')
        config.build_settings.delete('CODE_SIGNING_REQUIRED')
    end
end


def pods 
	# Pods for MGTimeRegister
	pod 'IQKeyboardManagerSwift', '~> 6.0.4'
    pod 'RxSwift', '~> 4.2.0'
    pod 'RxCocoa', '~> 4.2.0'
    pod 'RxDataSources'
end

target 'MGTimeRegister' do
    pods	

	target 'MGTimeRegisterTests' do
	    inherit! :search_paths
	    pods
  	end

end
            
