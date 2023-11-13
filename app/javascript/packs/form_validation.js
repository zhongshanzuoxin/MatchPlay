// 新規登録画面
document.addEventListener('turbolinks:load', function() {
  var nameField = document.getElementById('user_name');
  var invalidFeedback = document.querySelector('.invalid-feedback');
  var validFeedback = document.querySelector('.valid-feedback');

  function updateValidation() {
    if (nameField && invalidFeedback && validFeedback) {
      var consecutiveCharsRegex = /(\w)\1{4,}/; // 連続する同じ文字が5文字以上の場合に無効とする
      var isEmpty = nameField.value.trim() === '';

      // 名前が空または長さが適切でない場合のエラーメッセージ
      if (isEmpty || nameField.value.length > 15) {
        validFeedback.style.display = 'none';
        invalidFeedback.style.display = 'block';
        invalidFeedback.textContent = '名前を入力してください。';
      } else if (consecutiveCharsRegex.test(nameField.value)) {
        validFeedback.style.display = 'none';
        invalidFeedback.style.display = 'block';
        invalidFeedback.textContent = '同じ文字は連続で使用できません';
      } else {
        validFeedback.style.display = 'block';
        invalidFeedback.style.display = 'none';
      }
    }
  }
  if (nameField) {
    updateValidation();
    nameField.addEventListener('input', updateValidation);
  }
});



// ログイン画面
document.addEventListener('turbolinks:load', function() {
  var emailField = document.getElementById('email');
  var invalidFeedback = document.querySelector('.email-invalid-feedback');

  function updateEmailValidation() {
    if (emailField && invalidFeedback) {
      // メールアドレスのバリデーションを行う正規表現
      var isValidEmail = /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(emailField.value.trim());

      // 不正なメールアドレスの場合の処理
      if (!isValidEmail) {
        invalidFeedback.style.display = 'block';
        invalidFeedback.textContent = '正しいメールアドレスの形式で入力してください。';
        invalidFeedback.classList.add('error'); // CSSクラスを使用してスタイルを適用
      } else {
        invalidFeedback.style.display = 'none';
      }
    }
  }

  // メールフィールドが存在する場合にのみイベントリスナーを設定
  if (emailField) {
    emailField.addEventListener('input', updateEmailValidation);
  }
});



// ログイン画面
document.addEventListener('turbolinks:load', function() {
  var emailField = document.getElementById('email');
  var invalidFeedback = document.querySelector('.email-invalid-feedback');

  function updateEmailValidation() {
    if (emailField && invalidFeedback) {
      // メールアドレスのバリデーションを行う正規表現
      var isValidEmail = /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(emailField.value.trim());

      // 不正なメールアドレスの場合の処理
      if (!isValidEmail) {
        invalidFeedback.style.display = 'block';
        invalidFeedback.textContent = '正しいメールアドレスの形式で入力してください。';
        invalidFeedback.classList.add('error'); // CSSクラスを使用してスタイルを適用
      } else {
        invalidFeedback.style.display = 'none';
      }
    }
  }

  // メールフィールドが存在する場合にのみイベントリスナーを設定
  if (emailField) {
    emailField.addEventListener('input', updateEmailValidation);
  }
});
