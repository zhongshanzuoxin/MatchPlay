// turbolinks:loadイベントリスナーを追加
document.addEventListener('turbolinks:load', function() {
  // 特定のパターンの名前を持つセレクトボックスを全て取得
  const tagSelects = document.querySelectorAll(".form-select[name^='group[tag_ids]']");

  // 各セレクトボックスに対して処理を行う
  tagSelects.forEach(function(select, index) {
    // セレクトボックスの値が変更された際のイベントリスナーを追加
    select.addEventListener("change", function() {
      // 選択されている値を配列に変換
      const selectedValues = Array.from(tagSelects)
        .map(function(tagSelect) {
          return tagSelect.value; // 各セレクトボックスの値を取得
        })
        .filter(function(value) {
          return value !== ""; // 空の選択を除外
        });

      // 選択された値に重複があるかチェック
      if (selectedValues.length !== new Set(selectedValues).size) {
        alert("同じタグを複数選択することはできません"); // 重複がある場合にアラート表示
        this.value = ""; // 重複した選択をリセット
      }
    });
  });
});
