<template>
  <div class="col-xs-10 col-xs-offset-1"  id="app">
    <form action="" id="search-form" @submit="findMovie">
    <div class="row">
      <autocomplete @select='updateMovieValue' :suggestions="movies" ></autocomplete>
    </div>
    <div class="row">
    <div class="form-inline">
      <div class="form-group">
        <div class="checkbox disabled">
          <label><input type="checkbox" name="near-me" value="" v-model="nearMe">Рядом со мной</label>
        </div>
        <div class="checkbox disabled">
          <label><input type="checkbox" name="without-time" value="" v-model="withoutTime">Целый день</label>
        </div>
      </div>
    </div>
    </div>
    <div class="row">
       <div class="form-inline">
          <div class="form-group pull-right">
            <button type="submit" class="btn btn-default">Искать</button>
          </div>
        <i v-show="loading" class="fa fa-spinner fa-spin"></i>
        <div class="form-group" v-show="withTime">
          <label for="time-select">Выберите время:</label>
          <select class="form-control" id="time-select" v-model="showTime">
            <option v-for="time in times">{{time}}</option>
          </select>
        </div>
       </div>
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
      <tr v-if="showResults" v-for="show in shows">
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
        longitude: 0,
        latitude: 0,
        nearMe: false,
        withoutTime: false,
        showTime: '',
        shows: [],
        result_message: '',
        error:{
          message: '',
          class: 'alert alert-warning'
        },
        movies : [],
        movieValue: '',
        loading: false,
        times: []
      }
    },
    computed:{
      showResults(){
        return this.shows.length != 0;
      },
      showErrors(){
        return this.error.message.length != 0;
      },
      value(){
        return autocomplete.selection;
      },
      withTime(){
        return !this.withoutTime;
      }
    },
    methods: {
      findMovie(e){
        e.preventDefault();
        this.loading = true;
        const that = this
        that.shows = [];
        this.axios.post(`searchmovie`,
                        { search: {
                            show_time: this.showTime,
                            near_me: this.nearMe,
                            title: this.movieValue,
                            with_time: this.withTime,
                            longitude: this.longitude,
                            latitude: this.latitude
                            }
                        }
                ).then((response) => {
          this.clearError();
          that.result_message = response.data;
          if(response.data.length == 0){
             this.error.message = 'К сожалению, ничего не найдено';
          }
          response.data.forEach( info => {
            that.shows.push({
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
      },
      getTimes(){
        let times = [];
        let current_hour = new Date().getHours();
        while(current_hour < 24){
          times.push(`${current_hour}:00`);
          current_hour++;
        }
        times = times.concat(['00:00', '01:00', '02:00']);
        this.times = times;
      },
      getLocation(){
        navigator.geolocation.getCurrentPosition(this.saveLocation);
      },
      saveLocation(location){
        this.longitude = location.coords.longitude;
        this.latitude = location.coords.latitude;
      }
    },
    components:{
      'autocomplete': autocomplete
    },
    mounted(){
      this.moviePredict();
      this.getTimes();
      this.getLocation(this.saveLocation);
    }
  }
</script>

<style scoped>
  p {
    font-size: 2em;
    text-align: center;
  }
  .form-group{
    margin-top: 25px;
  }
  label{
    margin: 5px;
  }
  form{
    padding: 10px 0;
  }
  input{
    margin: 3px;
  }
</style>
