<template>
 <div id="my-modal" class="modal fade in">
 <div class="modal-dialog">
        <div class="modal-content">

        <div class="modal-header">
          <slot name="header">
            Поиск дешевых кинобилетов в москве
          </slot>
        </div>

        <div class="modal-body">
          <slot name="body">
          <ul>
            <li>Поиск работает только на сегодняшний день в городе Москве</li>
            <li>Когда отмечена галочка рядом со мной, агрегаттор выдает все киносеансы в радиусе 10 км</li>
            <li>Вся информация взята с сайта kinohod.ru</li>
            <li>Этот сайт предназначен для некоммерческого использования и сделан ради развлечения</li>
          </ul>
          </slot>
        </div>

        <div class="modal-footer">
          <slot name="footer">
            <button class="btn btn-default" @click="$emit('close')">
              OK
            </button>
          </slot>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
  export default{
    name: 'modalinfo'
  }
</script>

<style scoped>
.modal {
  display:block;
  position: fixed;
  top: 3%;
  right: 3%;
  left: 3%;
  width: auto;
  margin: 0;
}
  </style>
