<template>
  <nav class="navbar navbar-default">
    <div class="container-fluid">
    <div class="row">

        <div id="ticket-label">
            <i class="fa fa-ticket" id="ticket-two" aria-hidden="true"></i>
            <i class="fa fa-ticket" aria-hidden="true"></i>
        </div>
         <button class="btn btn-default pull-right" id="about"><a href="#" @click="$emit('showModal')">О проекте</a></button>
       </div>
    </div>
  </nav>
</template>

<script>
  export default{
    name: 'menuheader'
  }
</script>

<style scoped>
  #ticket-label{
    margin: 13px;
    font-size: 2em;
    text-shadow: 2px 2px 2px #ccc;
  }
  #ticket-two{
    position: relative;
    font-size: 1.5em;
    left: 20px;
  }
  #about{
    position: relative;
    top: -30px;
    right: 15px;
  }

</style>
