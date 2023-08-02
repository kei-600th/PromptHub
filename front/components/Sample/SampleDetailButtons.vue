<template>
  <v-row class="justify-end">
    <div v-if="sampleEditting === false">
      <v-btn color="appblue" class="white--text ma-5" @click="editSample()">
        サンプルを編集
      </v-btn>
      <v-btn
        :disabled="loading"
        :loading="loading"
        color="appblue"
        class="white--text ma-5"
        @click="deleteSample()"
      >
        サンプルを削除
      </v-btn>
    </div>
    <div v-if="sampleEditting === true">
      <v-btn
        :disabled="
          anyIsEmptyOrWhitespace(
            params.sample.title,
            params.sample.description,
          ) || loading
        "
        :loading="loading"
        color="appblue"
        class="white--text ma-5"
        @click="updateSample()"
      >
        編集を保存
      </v-btn>
      <v-btn
        color="appblue"
        class="white--text ma-5"
        @click="cancelEditSample()"
      >
        編集を取消
      </v-btn>
    </div>
  </v-row>
</template>

<script>
export default {
  props: ['loading', 'sampleEditting', 'params'],
  methods: {
    // necessary methods here
    anyIsEmptyOrWhitespace(...texts) {
      return texts.some((text) => text.trim() === '');
    },
    // pass these methods as event emit to parent component
    editSample() {
      this.$emit('editSample');
    },
    deleteSample() {
      this.$emit('deleteSample');
    },
    updateSample() {
      this.$emit('updateSample');
    },
    cancelEditSample() {
      this.$emit('cancelEditSample');
    },
  },
};
</script>
