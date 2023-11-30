document.addEventListener('turbolinks:load', function() {
  // 新規作成画面と編集画面の両方に対応するセレクター
  const selectBoxes = document.querySelectorAll(`.form-select[name^='group[tag_ids']`);

  selectBoxes.forEach(selectBox => {
    selectBox.addEventListener("change", function() {
      // 他のセレクトボックスの値を取得
      const otherSelectedValues = [];
      selectBoxes.forEach(otherSelectBox => {
        if (otherSelectBox !== selectBox && otherSelectBox.value !== "") {
          otherSelectedValues.push(otherSelectBox.value);
        }
      });

      // 現在のセレクトボックスの値が他のボックスと重複しているかチェック
      if (otherSelectedValues.includes(selectBox.value)) {
        alert("同じタグを複数選択することはできません");
        selectBox.value = ""; // 重複した選択をリセット
      }
    });
  });
});
