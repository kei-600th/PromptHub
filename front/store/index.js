// 変数
export const state = () => ({
  user: {
    current: null,
  },
  auth: {
    token: null,
    expires: 0,
    payload: {},
  },
  toast: {
    msg: null,
    color: 'error',
    timeout: 4000,
  },
  params: {
    category_id: null,
  },
});

// 算出プロパティ
export const getters = {
  isLoggedIn: (state) => !!state.user.current,
  isAdmin: (state) => (state.user.current ? !!state.user.current.admin : false),
  getCategoryId: (state) => state.params.category_id,
};
// stateの値を変更する場所
export const mutations = {
  setCurrentUser(state, payload) {
    state.user.current = payload;
  },
  setAuthToken(state, payload) {
    state.auth.token = payload;
  },
  setAuthExpires(state, payload) {
    state.auth.expires = payload;
  },
  setAuthPayload(state, payload) {
    state.auth.payload = payload;
  },
  setToast(state, payload) {
    state.toast = payload;
  },
  setCategoryId(state, payload) {
    state.params.category_id = payload;
  },
};

// メソッド
export const actions = {
  getCurrentUser({ commit }, user) {
    commit('setCurrentUser', user);
  },
  getAuthToken({ commit }, token) {
    commit('setAuthToken', token);
  },
  getAuthExpires({ commit }, expires) {
    expires = expires || 0;
    commit('setAuthExpires', expires);
  },
  getAuthPayload({ commit }, jwtPayload) {
    jwtPayload = jwtPayload || {};
    commit('setAuthPayload', jwtPayload);
  },
  getToast({ commit }, { msg, color, timeout }) {
    color = color || 'error';
    timeout = timeout || 4000;
    commit('setToast', { msg, color, timeout });
  },
  updateCategoryId({ commit }, newCategoryId) {
    commit('setCategoryId', newCategoryId);
  },
};
