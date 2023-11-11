document.addEventListener('turbolinks:load', function() {
  // 編集ボタンをクリックしてフォームを表示/非表示
  var editNameButton = document.querySelector('#edit-name');
  var editIntroductionButton = document.querySelector('#edit-introduction');

  if (editNameButton) {
    editNameButton.addEventListener('click', function() {
      var nameEditForm = document.querySelector('#name-edit-form');
      if (nameEditForm) {
        nameEditForm.style.display = 'block';
        editNameButton.style.display = 'none';
      }
    });
  }

  if (editIntroductionButton) {
    editIntroductionButton.addEventListener('click', function() {
      var introductionEditForm = document.querySelector('#introduction-edit-form');
      if (introductionEditForm) {
        introductionEditForm.style.display = 'block';
        editIntroductionButton.style.display = 'none';
      }
    });
  }
});
