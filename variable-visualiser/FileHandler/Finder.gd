extends FileDialog

signal path_selected(path, ident)

func _ready():
	self.popup_centered_clamped(Vector2(720, 420))
	self.canceled.connect(self._onFileDialogCanceled)
	self.file_selected.connect(self._onFileDialogSelected)

func _onFileDialogCanceled() -> void:
	self.propagate_call('queue_free', [])

func _onFileDialogSelected(path : String) -> void:
	if path:
		emit_signal('path_selected', path, 'audioFile')

	self.propagate_call('queue_free', [])
