Pod::Spec.new do |s|
  s.name             = 'RSBUndoManager'
  s.version          = '0.2.1'
  s.summary          = 'Lightweight extension of NSUndoManager w/ keypath-based undo/redo registration & memory awareness.'
  s.description      = s.summary
  s.homepage         = 'https://github.com/rosberry/RSBUndoManager'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Anton Kormakov' => 'anton.kormakov@rosberry.com' }
  s.source           = { :git => 'https://github.com/rosberry/RSBUndoManager.git', :tag => s.version.to_s }

  s.ios.deployment_target = '6.0'

  s.source_files = 'RSBUndoManager/Classes/**/*'
end
