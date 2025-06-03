const fetchData = async (url) => {
   const response = await fetch(`http://localhost:3000/${url}`);
   return await response.json();
}

const getDataFrames = async (url, timeframe) => {
   return await fetchData(url).then(obj => obj.timeframes[timeframe]);
}

const updateTimeFrames = (data, currentElements, previousElements, timeframe) => {
   data.forEach((obj, index) => {
      currentElements[index].innerText = `${obj.current}hrs`;
      previousElements[index].innerText = `Last ${timeframe} - ${obj.previous}hrs`;
   });
}

const showDataFrame = (nodeText) => {
   const currentElements = document.querySelectorAll('.current-time');
   const previousElements = document.querySelectorAll('.previous-time');

   let timeframe;
   switch (nodeText) {
      case 'Daily':
         timeframe = 'daily';
         break;
      case 'Weekly':
         timeframe = 'weekly';
         break;
      case 'Monthly':
         timeframe = 'monthly';
         break;
      default:
         return;
   }

   Promise.all([...Array(6).keys()].map(i => getDataFrames(i, timeframe)))
      .then(data => updateTimeFrames(data, currentElements, previousElements, nodeText.toLowerCase()));
}

const nav = document.querySelector('.nav');
nav.addEventListener('click', (el) => {
   showDataFrame(el.target.innerText);
});
