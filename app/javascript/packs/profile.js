document.addEventListener('turbolinks:load', function () {
  const editBtn = document.getElementById('edit-profile-btn');
  const editForm = document.getElementById('edit-profile-form');

  // editBtnとeditFormが存在する場合のみイベントを追加
  if (editBtn && editForm) {
    editBtn.addEventListener('click', function () {
      editForm.style.display = editForm.style.display === 'none' ? 'block' : 'none';
    });
  }
});
