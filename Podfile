# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'KoungaFamilyChoreRewards' do
  pod 'FirebaseAuth'
  pod 'FirebaseFirestore'
  pod 'FirebaseStorage'
  pod 'FirebaseMessaging'
  pod 'SDWebImageSwiftUI'
end

pre_install do |installer|
  installer.pod_targets.each do |pod|
    if pod.name.start_with?('FirebaseFirestore')
      def pod.build_type;
        Pod::BuildType.static_library
      end
    end
  end
end
