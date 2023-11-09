  document.addEventListener('DOMContentLoaded', function() {
    // 編集ボタンをクリックしてフォームを表示/非表示
    document.querySelector('#edit-name').addEventListener('click', function() {
      document.querySelector('#name-edit-form').style.display = 'block';
      document.querySelector('#edit-name').style.display = 'none';
    });

    document.querySelector('#edit-introduction').addEventListener('click', function() {
      document.querySelector('#introduction-edit-form').style.display = 'block';
      document.querySelector('#edit-introduction').style.display = 'none';
    });
  });