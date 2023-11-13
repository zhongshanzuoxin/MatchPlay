// フラッシュメッセージ関係
import toastr from 'toastr';

document.addEventListener('turbolinks:load', () => {
  // Toastrの初期化
  toastr.options = {
    closeButton: true,
    progressBar: true,
    positionClass: 'toast-top-center',
    timeOut: '5000', // メッセージの表示時間
    extendedTimeOut: '2000', // フェードアウトまでの時間
    fadeOut: 1000, // フェードアウトの速さ
    showMethod: 'fadeIn', // 表示時のアニメーション
    hideMethod: 'fadeOut' // 非表示時のアニメーション
  };

  // フラッシュメッセージがあれば表示
  const flashNotice = document.body.getAttribute('data-flash-notice');
  if (flashNotice) {
    toastr.success(flashNotice);
  }

  const flashAlert = document.body.getAttribute('data-flash-alert');
  if (flashAlert) {
    toastr.error(flashAlert);
  }
});
