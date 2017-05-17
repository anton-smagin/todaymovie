<template>
  <div class="col-xs-10 col-xs-offset-1"  id="app">
    <form action="" id="search-form" @submit="findMovie">
    <autocomplete @select='updateMovieValue' :suggestions="movies" ></autocomplete>
    <div class="form-group">
      <button type="submit" class="btn btn-default">Искать</button>
      <i v-show="loading" class="fa fa-spinner fa-spin"></i>
    </div>
    </form>
    <div class="row">
    <div :class="error.class" v-show="showErrors">
      {{error.message}}
    </div>
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
import autocomplete from './autocomplete.vue';
  export default {
    data: function () {
      return {
        showes: [],

        result_message: '',
        error:{
          message: '',
          class: 'alert alert-warning'
        },
        movies : [],
        movieValue: '',
        loading: false
      }
    },
    computed:{
      showResults(){
        return this.showes.length != 0;
      },
      showErrors(){
        return this.error.message.length != 0;
      },
      value(){
        return autocomplete.selection;
      }
    },
    methods: {
      findMovie(e){
        e.preventDefault();
        this.loading = true;
        const that = this
        that.showes = [];
        this.axios.get(`cheapest_by_title?title=${this.movieValue}`).then((response) => {
          this.clearError();
          that.result_message = response.data;
          if(response.data.length == 0){
             this.error.message = 'К сожалению, ничего не найдено';
          }
          response.data.forEach((info) => {
            that.showes.push({
              theater: info.cinema.name,
              address: info.cinema.address,
              time: info.show.time,
              price: info.show.price,
            });
          })
          console.log(that.result_message);
          this.loading = false;
        }).catch((e) => {
          this.error.message = e.response.data.error;
          this.loading = false;
        });
      },
      moviePredict(){
        this.axios.get('movietitles').then((response) => {
          console.log(response.data);
          this.movies = response.data;
        }).catch((e) => {
          this.error.message = e.response.data.error;
        });
      },
      clearError(){
        this.error.message = '';
      },
      updateMovieValue(data){
        this.movieValue = data;
      }
    },
    components:{
      'autocomplete': autocomplete
    },
    mounted(){
      this.moviePredict();
    }
  }
</script>

<style scoped>
  p {
    font-size: 2em;
    text-align: center;
  }
</style>
