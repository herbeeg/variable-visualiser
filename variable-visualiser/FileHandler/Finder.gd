extends FileDialog
# Track the audio file path and identifier.
signal path_selected(path, ident)

func _ready():
	self.applyMods()
	
	self.canceled.connect(self._onFileDialogCanceled)
	self.file_selected.connect(self._onFileDialogSelected)

func applyMods() -> void:
	# Clamp dialog window to the centre of the application.
	self.popup_centered_clamped(Vector2(720, 420))
	# Only allow specific audio files to be selected.
	self.add_filter('*.wav, *.mp3, *.ogg', 'Audio Files')
	# Only permit access to the local Godot project resources.
	self.access = FileDialog.ACCESS_RESOURCES
	# Avoid warping of audio file selection dialog.
	self.unresizable = true

func _onFileDialogCanceled() -> void:
	# Clear the node from the tree to avoid duplication.
	self.propagate_call('queue_free', [])

func _onFileDialogSelected(path : String) -> void:
	if path:
		# Pass the path to the viewport loader.
		emit_signal('path_selected', path, 'audioFile')

	self.propagate_call('queue_free', [])
