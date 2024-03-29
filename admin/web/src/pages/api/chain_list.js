import { getChainList } from '/src/helper/chain_registry';

export default async (req, res) => {
  const chainList = await getChainList();

  res.status(200).json(chainList);
}
