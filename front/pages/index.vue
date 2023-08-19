<template>
  <div>
    <SelectCategory
      :category-id="params.category_id"
      :categories="categories"
      @updateCategory="params.category_id = $event"
    />
    <v-row>
      <v-col
        v-for="(sample, index) in samples"
        :key="index"
        cols="12"
        :sm="card.sm"
        :md="card.md"
      >
        <v-card
          :height="card.height"
          :elevation="card.elevation"
          max-width="344"
          :to="`/sample/${sample.id}`"
          class="v-btn text-capitalize mx-auto"
        >
          <v-img :src="'https://lh3.googleusercontent.com/pw/AIL4fc87YlTPgoOnhm0OS7zoWXONVk-b64VIO-ratQeVc5RUKqM6a_iWo7VcVo5tkXBPtfZ9-A5lCYSX5cgFTqdT50uETlf-TdBAS7R5gAXWAEN04N1BxUgJU8lv0NKtQikFybM1vyQbGiFb09u_5R8duzd5Yfc6HAxqXL8Mnkj5Fss8dA56ummNP0plPqYxfrkWgvdmqqMi0jHFT5xcJrjal5E7GwaE6DAmd1FSQDwiomAsC-fyVW_MX2lDBX1OgSLyVEm8rfTqFeGLBgQgMFsI042cp_wN8zY6DRcT9aNO6oQ_3d5YOUDp3Oz1Cqd5CFHggbJw4uougVs1SJL_elfdHKCxLMfeVzUG1ymDFLRcs1qgIvIURRdk6-tKtNxjuiViZIGYMVSI7ih1BdQTtXEPGjy15e8_vtF5X104wlcQ-OjPrJo-jUsZ74iKgR3szYlze6nqlKeELJD2tkvRRjPnV-Se9yLJ2H2Ucz3XpJhV4n6XepDEUq8S60WonCq2J5an5bHQCKejdewuSxXY2TDwwoHTBd2sKpVihiMP-3Y1HurrgewJh5mEW5vjZlH5heGWpD1dViqE4FJkWgYl4kHvIbcw5UUXjxYuxrh3ykBztPUyytxuUTBCFUlcHDNwOOrjzjnhU_s-yXrnGmy_r1T_KpSpAmFO4kHbs7jFW8BWzoSxm21CkhGOrMsCal4xpdC5GxL_gmeQCrDqBwZIDjU443Td5FB0Z61Z3kniOOST7nwq-xKF9JfnrdOD1Ry8PyuTmMH0v1kgNXdShL5sNE9TpeKKQd2qD5v6P2n6Z3t9XJ916gwgvzB36-xoyzITkv63W69F-wM2s8kroUTZDHzp-x1o3U41bM7yAGSKADu-HSYj9ZPaoWeInLEhkWKcEBtbPl72LxNjdzCd1ORvsiBDYjEYzKDW6b_uM7oEzsZSFLIN1rqqq32wPlJd0o1wl9A=w855-h855-s-no?authuser=0'" height="150" class="white--text align-end">
            <v-overlay absolute>
              <v-card-title>
                {{ sample.title }}
              </v-card-title>
              <v-chip class="ma-2" size="small" color="primary">
                {{ sample.category.name }}
              </v-chip>
            </v-overlay>
          </v-img>
        </v-card>
      </v-col>
    </v-row>
  </div>
</template>

<script>
import SelectCategory from '@/components/Category/SelectCategory.vue';
import { handleFailure } from '@/plugins/error-handler';
export default {
  components: {
    SelectCategory,
  },
  data() {
    return {
      params: {
        category_id: null,
      },
      categories: [
        { id: null, name: 'すべてのカテゴリ' }
      ],
      samples: [],
      card: {
        sm: 6,
        md: 4,
        height: 150,
        elevation: 4,
      },
    };
  },
  watch: {
    'params.category_id': function(newCategoryId, oldCategoryId) {
      if (newCategoryId !== oldCategoryId) {
        this.getSamples(); // カテゴリIDが変更された時にサンプルを更新
      }
    },
  },
  async mounted() {
    await this.getSamples();
    try {
      const response = await this.$axios.$get('/api/v1/categories');
      this.categories = [{ id: null, name: 'すべてのカテゴリ' }, ...response];
    } catch (error) {
      handleFailure(error, this.$store);
    }
  },
  methods: {
    async getSamples() {
      try {
        const response = await this.$axios.$get('/api/v1/samples/', {
          params: { category_id: this.params.category_id } // カテゴリIDをパラメータとして追加
        });
        this.samples = response;
      } catch (error) {
        handleFailure(error, this.$store);
      }
    },
  },
};
</script>
