<template>
  <div class="col-xs-10 col-xs-offset-1"  id="app">
    <form action="/">
    <div class="form-group">
      <input type="text" class="form-control" placeholder="Введите название фильма" id="search-movie" v-model="search_query">
    </div>
    <div class="form-group">
      <button type="submit" class="btn btn-default" @click='find_movie'>Искать</button>
    </div>
    </form>
    <div class="row">
    <table class="table table-striped" v-show="showResults">
    <thead>
      <tr>
      <td>Кинотеатр</td>
      <td>Aдрес</td>
      <td>Время</td>
      <td>Цена</td>
      </tr>
    </thead>
    <tbody>
      <tr v-if="showResults" v-for="show in showes">
        <td>{{show.theater}}</td>
        <td>{{show.address}}</td>
        <td>{{show.time}}</td>
        <td>{{show.price}}</td>
      </tr>
    </tbody>
    </table>

    </div>
  </div>

</template>

<script>
  export default {
    data: function () {
      return {
        showes: [],
        search_query: '',
        result_message: '',
      }
    },
    computed:{
      showResults(){
        return this.showes.length != 0;
      }
    },
    methods: {
      find_movie(e){
        e.preventDefault();
        const that = this
        this.axios.get(`cheapest_by_title?title=${this.search_query}`).then(function(response) {
            that.result_message = response.data;
            that.showes = [];
            response.data.forEach((info) => {
              that.showes.push({
                theater: info.cinema.name,
                address: info.cinema.address,
                time: info.show.time,
                price: info.show.price,
              });
            })
            console.log(that.result_message);
        })
      }
    }
  }
</script>

<style scoped>
  p {
    font-size: 2em;
    text-align: center;
  }
</style>
