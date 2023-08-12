export function handleFailure(error, store) {
  if (error.response) {
    const msg = error.response.data.error;
    return store.dispatch('getToast', { msg });
  }
}
