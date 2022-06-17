javascript:function sleep(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
}
let size = 0;
let focusStop = false;
let countAds = 0;

async function findMatchUrl() {
    const input = document.getElementsByClassName('cz3goc BmP5tf');
    if (size === input.length) {
        return 2;
    } else {
        size = input.length;
    }
    for (let i = 0; i < input.length; i++) {
        const item = input[i];
        const spanQc = item.querySelector('div > div > span');
        if (spanQc != null) {
            countAds++;
            const href = item.getAttribute('href');
            console.log(href);
            if (url.toLowerCase() === href.toString().toLowerCase() || href.toString().toLowerCase().startsWith(url)) {
                console.log(item);
                item.scrollIntoView({block: 'end', behavior: 'smooth'});
                await sleep(2000);
                item.click();
                return 0;
            }
        }
    }
    return 1;
}

async function clickMore() {
    const items = document.getElementsByClassName('GNJvt ipz2Oe');
    items[0].scrollIntoView({block: 'end', behavior: 'smooth'});
    await sleep(2000);
    items[0].click();
}

function waitLoadingHidden(i, url) {
    sleep(1000).then(r => {
        if (document.querySelector('[class="QjmzCd"][role="progressbar"]').style.display !== 'none') {
            waitLoadingHidden(i, url);
        } else {
            console.log('loading hidden');
            findAndClickMore(i, url);
        }
    });
}

function findAndClickMore(i, url) {
    if (focusStop) {
        return;
    }
    if (i <= " + Setting.getInstance().numberPager() + ") {
        findMatchUrl(url).then(r => {
            let bool = r;
            if (bool === 1) {
                i++;
                clickMore().then(r => {
                    waitLoadingHidden(i, url);
                    if (i === 10) {
                        console.log('cant find url of key,-2');
                        // console.error(-2, 'cant find url of key');
                    }
                });
            } else {
                if (bool === 2) {
                    focusStop = true;
                    console.log('cant find url of key,-2');
                    // console.error(-2, 'cant find url of key');
                } else {
                    console.log('done load url');
                    // console.done(0);
                }
            }
        });
    }
}

findAndClickMore(0, 'https://khoacuahomekit.com/');
